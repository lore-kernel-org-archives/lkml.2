Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0JYCBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:01:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53959 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0JYCBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nDTyzLu35dAGGItR+fVgb/KbqAt+iT7MqmfINqJh1evf84YU7AO60vogSD/LHE37ZT
         Vi+3GqHDAhiJ1MeVFHmGPKxzuvK9FCcrvEsmqirWU89NK6AXAB2qVSq5l8Gmq7Lw0iMH
         6kfp0TzvZ1qoqWry82LVwIy8HqjrRmCnAm70c=
Subject: Re: [PATCH 0/29] My patch queue for memorystick subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 04:01:10 +0200
Message-ID: <1287972070.5205.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-23 at 01:53 +0200, Maxim Levitsky wrote:
> Hi,
> 
> As requested, this is split up series of the work I did for the
> memorystick subsystem.
> 
> All patches compile tested.
> All patches except jmicron patches also run tested on my r592
> The end result of jmicron patches is exactly the same as my old patch
> that did work very well. I will test the patches tommorow though to ensure that
> all of them work for bisectability.
> 
> Please review & merge.
Any update?
Can I expect this in 2.6.37?

Best regards,
	Maxim Levitsky

