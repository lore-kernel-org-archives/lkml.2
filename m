Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2JTJ24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 05:28:56 -0400
Received: from mga12.intel.com ([143.182.124.36]:62924 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751413Ab2JTJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 05:28:55 -0400
Message-ID: <1350723752.2393.3.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH V2 01/10] Secure boot: Add new capability
From: Matt Fleming <matt.fleming@intel.com>
To: joeyli <jlee@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Date: Sat, 20 Oct 2012 10:02:32 +0100
In-Reply-To: <1350692142.14835.46.camel@linux-s257.site>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-2-git-send-email-mjg@redhat.com>
	 <1350692142.14835.46.camel@linux-s257.site>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 08:15 +0800, joeyli wrote:
> Hi Matt, 
> 
> Sorry for bother you!
> 
> I didn't see this Matthew's patchset merged in EFI git tree. Do you have
> plan to merge it? Or those patches need wait different subsystem leaders
> merge.

I don't think it makes sense for the secure boot patch series to go
through the EFI tree as it touches a lot of other subsystems.



