Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab0FFRt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 13:49:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43223 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab0FFRt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 13:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=T20NvXHEVkFA9UhDxvb+fM1kfj1VGqWkQP9uslEpf6bsTaRrJs7T42ckAlc2QfVf1U
         icyc49eSk1T/TcO06s9RONOPXjhzDsX3oqrTjzU/Cvo5mRWashwLxkwvXUpJA3mWEvII
         S32DaH/qKqJLVLkqPRiiXbX3/Mg/sDBZNJCrI=
Message-ID: <4C0BDFA4.8070708@gmail.com>
Date: Sun, 06 Jun 2010 19:49:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100527 SUSE/3.1rc1-3.3 Thunderbird/3.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
CC: linux-kernel@vger.kernel.org, Justin Mattock <justinmattock@gmail.com>
Subject: Re: BUG: Bad page map 2.6.35-rc2
References: <4C0BCC22.8010107@odi.ch>
In-Reply-To: <4C0BCC22.8010107@odi.ch>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2010 06:26 PM, Ortwin Glück wrote:
> After booting ntp was consuming 100% CPU. strace gave nothing. Sending it a TERM
> spew the following into syslog. Ran it through ksymoops.
> 
> 
> Jun  6 18:08:39 mithril kernel: BUG: Bad page map in process ntpd  pte:07200720

Hmm, again 0720 pattern. It's very likely the same as
http://lkml.org/lkml/2010/6/6/7

-- 
js
