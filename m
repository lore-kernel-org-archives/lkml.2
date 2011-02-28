Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1B1MLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:11:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1B1MLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:11:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Waychison <mikew@google.com>
Subject: Re: [klibc] [PATCH] build: Define __EXPORTED_HEADER__
Date: Mon, 28 Feb 2011 13:11:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: klibc@zytor.com, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org
References: <1298506377-16796-1-git-send-email-mikew@google.com> <201102272107.48934.arnd@arndb.de> <AANLkTikijjZwQp6Fer9TqRqQe=2WhSCPcDv5mczcGD8g@mail.gmail.com>
In-Reply-To: <AANLkTikijjZwQp6Fer9TqRqQe=2WhSCPcDv5mczcGD8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281311.16811.arnd@arndb.de>
X-Provags-ID: V02:K0:ybdA14HCG5xju3VcLWjZ6epA6YMcSr+vGTVuN8nEO67
 BwLcaHWjEf4ggp0jABNEWjihjplEacVVRu/3j/N0wBvYfRnW1K
 7TjL+6ql1xaN2APGfpSX/N++3gOKERHzsY91LP8XRcKpulhWKA
 sBzKmxcsQUKb1fd1Px7Owgqk0jGbfFR/7IchfJcZs13yTyI2T5
 SewC59bq0d70dxFjuWOpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 February 2011, Mike Waychison wrote:
> How is one expected to test if the files should be rebuild or not?
> Forcing a headers_install as part of a build will cause the entire
> userland to be rebuilt.

How about changing headers_install to only install files that have
changed? Make headers_install alreadh knows the list of all files
it is installing.

	Arnd
