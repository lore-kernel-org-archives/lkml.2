Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab2F0PlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:41:09 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:36561 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2F0PlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:41:07 -0400
Message-ID: <1340811461.16730.551.camel@misato.fc.hp.com>
Subject: Re: [PATCH v6 5/6] ACPI: Add _OST support for ACPI container hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        shuahkhan@gmail.com, liuj97@gmail.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 09:37:41 -0600
In-Reply-To: <4FEAA2C0.5060804@jp.fujitsu.com>
References: <1340743374-18535-1-git-send-email-toshi.kani@hp.com>
	 <1340743374-18535-6-git-send-email-toshi.kani@hp.com>
	 <4FEAA2C0.5060804@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 15:05 +0900, Yasuaki Ishimatsu wrote:
> 2012/06/27 5:42, Toshi Kani wrote:
> > Changed container_notify_cb() to call ACPI _OST method when ACPI
> > container hotplug operation has completed. Slightly restructured
> > the code with the same logic except that the hot-add case will
> > fail a request whenever device is set. This makes the error check
> > to be more comprehensive.
> > 
> > The function sets eject_pending bit for an eject request since it
> > does not initiate hot-remove operation. This bit is checked by the
> > sysfs eject handler to determine if the request is originated from
> > an ACPI eject notification.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> Thank you for updating the change log.
> 
> Reviewed-by: <isimatu.yasuaki@jp.fujitsu.com>

Thanks Yasuaki for reviewing!
-Toshi

