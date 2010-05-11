Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab0EKO0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:26:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61783 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab0EKO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r7cZYBK/R4RGZxqchB6rK07VufeS+iKuz9KinS59PmpR753NEfWFd7+a67hIY8s+MX
         K6YpVfB5SgbRIVDL3l+yy09iWU2wohXf4sQgIc0DGYxiDcCDEJsSx9KpirtAvFbJLwV9
         bPEctpxW5tZLndSctZ1P593KXae4SGMamir5s=
Message-ID: <4BE96910.7090602@gmail.com>
Date: Tue, 11 May 2010 07:26:24 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-bluetooth@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: magicmouse: claimed by neither input, hiddev nor hidraw
References: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>  <alpine.LRH.2.00.1005102334140.14809@twin.jikos.cz> <s2odd18b0c31005101439v22d03bfdw4e65d7c4b8315b6a@mail.gmail.com> <alpine.LNX.2.00.1005102351220.28092@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1005102351220.28092@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k... I went and tested individual commits
and right now if I git revert 28918c
on the latest head, I don't receive
the "claimed by neither input, hiddev nor hidraw"
message, and I get all functionality back with the mouse.
(without having hiddraw enabled in the kernel.

Justin P. Mattock
