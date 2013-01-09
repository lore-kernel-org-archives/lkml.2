Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273Ab3AIV1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:27:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab3AIV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:27:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH 1/4] arm: vt8500: Add support for Wondermedia WM8750/WM8850
Date: Wed, 9 Jan 2013 21:27:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
References: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz> <CAOesGMj6XTuW9tPqYnawPvO-wJBd7s5M5xTfdvQcmEioHw=Pnw@mail.gmail.com> <1357758570.27076.8.camel@gitbox>
In-Reply-To: <1357758570.27076.8.camel@gitbox>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092127.05804.arnd@arndb.de>
X-Provags-ID: V02:K0:Jp5ekt/YEEawfZIXZK5/OPvbCVgF/vVR6SE0T/QQDJB
 3WRN0BYmYGQyRkzRj32CHXSmhjpvpH3EWYVKs8L6YNL5xQz86h
 B7OvQ0KJHkTFV+4mNBHgTE3uQpfWNLFWHUwz5Kwk9lo4jfjwyG
 vA/7jR3Q80FNtCLtPU6Ez8gdY+y6Db5bYs+zhGjM5CfNN91H0c
 LMsfGZjpnUysdoTWqGWKrT0M9IY/7RBa98ykUSgbJGQZnKS4Fs
 Z9FIk00NaraffRanJAprxlNjWTZSwsGEAAEZ9IJqU0rEI0s6s0
 rXVoERofZa3PTCbBCHVPbDEwOURec4fhCMyBh0yg+4lzdALzM/
 aIqv4JlbXwBJSyhHT9L8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Tony Prisk wrote:
> I'm quite happy to send a pull request if that's what you prefer.
> 
> Generally people have just taken the patches straight from email, so
> everytime I've done a pull-request I get a reply back saying the patches
> have already been applied.
> 
> Is there some 'rule' around pull-requests vs emailed patches?

Generally, pull requests tend to be less work for us, so I prefer
them. In particular, when you add a tag description or a signed
tag, that gives automatically puts  nice text into the merge
changeset.

> Should patches in pull-requests have Ack'd lines already?

Yes.

	Arnd

