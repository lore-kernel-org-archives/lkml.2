Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353Ab2JXReJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:34:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59296 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935257Ab2JXReH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:34:07 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+IbX175I2IqRIKxKkqr606SSEhFLWAxgTP9GyR5z
	f0C/K0kla6+JNW
Message-ID: <5088260D.7080403@gmx.de>
Date: Wed, 24 Oct 2012 19:31:57 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121022 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error w/ external USB drive
References: <507C4BDA.20205@gmx.de> <20121019210723.GA4721@thunk.org> <5085923F.9050801@gmx.de> <20121024011128.GG28626@thunk.org>
In-Reply-To: <20121024011128.GG28626@thunk.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 03:11 AM, Theodore Ts'o wrote:
> Toralf,
> 
> Are you using any kind of special mount options on your usb stick?
> 
> Thanks,
> 
> 						- Ted
nope

tfoerste@n22 ~/devel/linux $ grep ext4 /etc/fstab
/dev/sdb3               /               ext4            noatime
        0 1


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
