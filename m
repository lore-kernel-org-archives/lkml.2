Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2DRQqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:46:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40210 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab2DRQqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:46:08 -0400
Message-ID: <4F8EEFB5.8040604@zytor.com>
Date: Wed, 18 Apr 2012 09:45:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lasse Collin <lasse.collin@tukaani.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, qasdfgtyuiop <qasdfgtyuiop@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alain@knaff.lu,
        albin.tonnerre@free-electrons.com
Subject: Re: [PATCH] kconfig: update compression algorithm info
References: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com> <4F8DF90B.1090002@xenotime.net> <20120418194055.2d929e58@tukaani.org>
In-Reply-To: <20120418194055.2d929e58@tukaani.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 09:40 AM, Lasse Collin wrote:
>   - LZO should give the fastest boot from a hard disk (desktop systems
>     where file size doesn't matter much).

That really depends on the speed of your disk vs CPU.

	-hpa


