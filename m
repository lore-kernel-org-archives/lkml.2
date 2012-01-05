Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab2AEPy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:54:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51156 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645Ab2AEPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:54:56 -0500
Message-ID: <4F05C7CB.3000607@lwfinger.net>
Date: Thu, 05 Jan 2012 09:54:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Joe Perches <joe@perches.com>, Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] rtlwifi: Standardize RT_PRINT_DATA macro and uses
References: <cover.1325734202.git.joe@perches.com> <e7d4163a9897f33145d8a07be54f507ab68e0243.1325734203.git.joe@perches.com> <20120105114314.GD2222@redhat.com>
In-Reply-To: <20120105114314.GD2222@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 05:43 AM, Stanislaw Gruszka wrote:
> Hi Joe
>
> On Wed, Jan 04, 2012 at 07:40:40PM -0800, Joe Perches wrote:
>>   	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
>
> Since you are working on it, can you also get rid of this DBG_*
> parameter, if rtlwifi maintainers are ok with that? It is additional
> console loglvevel, standard kernel loglevel should be used.

I'm not OK with that. Those DBG_* parameters are used in conjunction with a 
load-time debug parameter to set the level of debugging. You could rename all of 
them, but that would be useless churning of the source with no real value.

Larry

