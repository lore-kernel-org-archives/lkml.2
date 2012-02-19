Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2BSVKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:10:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39069 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2BSVKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:10:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.120.207 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F41653A.3090307@gmail.com>
Date: Sun, 19 Feb 2012 22:10:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: TTY: NULL dereference when closing a pty file
References: <1329683796.10124.21.camel@lappy>
In-Reply-To: <1329683796.10124.21.camel@lappy>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 09:36 PM, Sasha Levin wrote:
> I got the following BUG() when running trinity on the KVM tool:

Hi, I've sent a patch as a reply to your message. Could you test it?

And where can one obtain the tool?

thanks,
-- 
js
