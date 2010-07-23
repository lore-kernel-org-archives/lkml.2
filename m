Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab0GWTUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:20:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33691 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0GWTU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=qjUaKdYihk7Asy5XCAcxJH6JHDfb+2yGqSgfMoWj+gXe6Ssj7Yjt9QuxM//nhYiZrt
         UnEVFZR7ayfxJq0kHE9ZqWESayVQaQVtzQdcVUUWBuVRtbP+uMXqPyzXGxsUL/xSOTYS
         S6Z6hIQfOt7qBs3Tt/T1ODdQ0PWokqDgJslFQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: caiqian@redhat.com
Subject: Re: 2.6.35-rc5 panic at __br_deliver+0x64/0xe0 with kvm bridge networking
Date: Fri, 23 Jul 2010 21:20:22 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc6; KDE/4.4.4; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Dave Anderson <anderson@redhat.com>, Avi Kivity <avi@redhat.com>
References: <198123598.1050221279855515402.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <198123598.1050221279855515402.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007232120.23206.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 23 lipca 2010 o 05:25:15 caiqian@redhat.com wrote:
> I met consistently host panic when operated under kvm guest with bridge
> networking. I got a vmcore (unfortunately, the crash utility had some
> problems to analyse it fully), and full panic log is attached.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16448
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
