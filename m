Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab0JQSkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:40:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54244 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab0JQSkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=kWpreDTNTJkTVSfGpQH7zxd+0HfmKtZsbhRwRUCJP8pzfaRkcDYcwJTYH00Ul6hz1J
         MwHMEi+PRMfjSf7TjlsDfXf1XrMT6Tpwai77oiUDN6I3gP+2Djts2fhxpqlXgYXL/t3A
         khVjwVDZ/SdxSlB5sBuwKLEU2zclAmRfpc2ec=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
Date: Sun, 17 Oct 2010 20:34:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7; KDE/4.4.5; i686; ; )
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
        "linux-net maillist" <linux-net@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz
References: <20101015071008.GA8714@pcnci.linuxbox.cz>
In-Reply-To: <20101015071008.GA8714@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010172034.16781.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 15 października 2010 o 09:10:08 Nikola Ciprich wrote:
> Hi,
> 
> when I try to boot 2.6.36-rc7-git2 on one of my machines, it crashes while
> setting up the network. The setup is quite complex, with bonding, lots of
> vlans and 3 intel adapters (system is quad x86_64)
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=20462
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
