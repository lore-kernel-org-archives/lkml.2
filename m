Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab2CIUu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:50:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33513 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759363Ab2CIUu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:50:27 -0500
Message-ID: <4F5A6D09.3050704@zytor.com>
Date: Fri, 09 Mar 2012 12:50:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: mtk.manpages@gmail.com, akpm@linux-foundation.org, xemul@parallels.com,
        linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/2] Add kcmp.2 manpage
References: <1331326042-32558-1-git-send-email-gorcunov@openvz.org> <1331326042-32558-3-git-send-email-gorcunov@openvz.org>
In-Reply-To: <1331326042-32558-3-git-send-email-gorcunov@openvz.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 12:47 PM, Cyrill Gorcunov wrote:
> +.I v2
> +, but ordering information is unavailble.

Needs to be:

.IR v2 ,

... and fix the typo in "unavailable".

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

