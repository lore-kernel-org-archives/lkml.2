Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab1AMWKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:10:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab1AMWKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:10:41 -0500
Message-ID: <4D2F784E.9080103@redhat.com>
Date: Thu, 13 Jan 2011 23:10:22 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrea Gelmini <andrea.gelmini@gelma.net>
CC: linux-doc@vger.kernel.org,
        "Randy Dunlap (maintainer:DOCUMENTATION)" <rdunlap@xenotime.net>,
        "Thomas Weber (commit_signer:1/3=33%)" <weber@corscience.de>,
        "Mike Frysinger (commit_signer:1/3=33%)" <vapier.adi@gmail.com>,
        "Jiri Kosina (commit_signer:1/3=33%)" <jkosina@suse.cz>,
        "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Documentation: dm-crypt: update cryptsetup homepage
References: <1294956113-6630-1-git-send-email-andrea.gelmini@gelma.net>
In-Reply-To: <1294956113-6630-1-git-send-email-andrea.gelmini@gelma.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 11:01 PM, Andrea Gelmini wrote:
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  Documentation/device-mapper/dm-crypt.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
> index 59293ac..6b5c42d 100644
> --- a/Documentation/device-mapper/dm-crypt.txt
> +++ b/Documentation/device-mapper/dm-crypt.txt
> @@ -41,7 +41,7 @@ Example scripts
>  ===============
>  LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
>  encryption with dm-crypt using the 'cryptsetup' utility, see
> -http://clemens.endorphin.org/cryptography
> +http://code.google.com/p/cryptsetup/

yes, that's the upstream page for cryptsetup/LUKS now, I will probably add some
page describing dm-crypt kernel target there too.

Acked-by: Milan Broz <mbroz@redhat.com>

Milan
