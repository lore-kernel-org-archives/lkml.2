Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab0JFBu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:50:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38969 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0JFBuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=LG2riGoXRkfxi7WVjdnmT+zyaKWAUXL1rCkl5nFuwvY3dSRj0UrkjPXvc7Cu6L9ZiH
         bq74DMJZ4Ri2BQd6EH2Bn6uGBdmgkcDRAXQPbDVNxH9i0yTLGO+hPzToW1TGgrzWFy5t
         ooju7A5l1UkFLAkqjmtSk5HaFwzYtpDeaSQ2o=
Subject: Re: Why not distribute timer handlers on CPUs on SMP
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: bhs <haishan.bai@gmail.com>
In-Reply-To: <2B624B3F-9338-4336-B4F6-D61B476DA255@gmail.com>
Date: Wed, 6 Oct 2010 09:50:48 +0800
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AD61E4A9-2622-47F8-911C-A2FCF9F34BF8@gmail.com>
References: <2B624B3F-9338-4336-B4F6-D61B476DA255@gmail.com>
To: bhs <haishan.bai@gmail.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6, 2010, at 9:05 AM, bhs wrote:

> Hello,
> 
> I am just curious about why handle the timer functions on a CPU serially but not distribute them over CPUs
> even on a SMP system?
> 


Yea, it already distributed over CPUs at calling add_timer(), timer function was bounded to a cpu on which
it was created.

I am sorry for my noise.

 
> The timer wheel handler function __run_timers() serializes the timer functions on a CPU,
> is there any design consideration that handling timers on a CPU is more reasonable than distribute them
> over CPUs?
> 
> 
> Best regards
> Shan Hai

