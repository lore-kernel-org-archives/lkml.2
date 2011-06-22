Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab1FVDLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:11:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33272 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab1FVDLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IB7uuyfRBRLMf1SM0gvLX4p/RZ0088rW26f1cNkrajn9W5YLYW9nDozZgUNCrDjM2P
         pNDgMsW9u9h+xGXsCJtQtuIzeMjYzgheEMFP/4KuLytgE5diK0dSFaNZe1HVcboeJoSD
         hO8sGNfegdR5NRDPU71vrzIgYl4VBqFunFrZA=
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor
 messaging bus
From: Sasha Levin <levinsasha928@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>
In-Reply-To: <87liwu8u3q.fsf@rustcorp.com.au>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	 <1308640714-17961-8-git-send-email-ohad@wizery.com>
	 <87liwu8u3q.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 21 Jun 2011 23:11:27 -0400
Message-ID: <1308712287.11435.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 12:12 +0930, Rusty Russell wrote:
> > +#define VIRTIO_ID_RPMSG		10 /* virtio remote processor messaging */
> 
> I think you want 6.  Plan 9 jumped ahead to grab 9 :)

Maybe it's worth adding an appendix to the virtio spec as part of this
(and really any) patch series which takes a virtio ID.

Also, I understand that virtio itself as an idea isn't Linux specific,
but maybe it's worth including the spec (or at least a variation of it)
as part of the kernel documentation.

-- 

Sasha.


