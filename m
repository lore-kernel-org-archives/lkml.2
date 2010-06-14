Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0FNKPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:15:08 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:43837 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab0FNKPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:15:06 -0400
Message-ID: <4C1600C5.2000907@mev.co.uk>
Date: Mon, 14 Jun 2010 11:13:25 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100422 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gustavo Silva <silvagustavosilva@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "wfp5p@virginia.edu" <wfp5p@virginia.edu>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "silvagustavo@users.sourceforge.net" 
	<silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH] Staging: comedi: drivers: fix coding style issues in
 pcl812.c
References: <>  <1276399541-12127-1-git-send-email-silvagustavo@users.sourceforge.net>
In-Reply-To: <1276399541-12127-1-git-send-email-silvagustavo@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/10 04:25, Gustavo Silva wrote:
> + * Driver: pcl812
> + * Description: Advantech PCL-812/PG, PCL-813/B,
> + *          ADLink ACL-8112DG/HG/PG, ACL-8113, ACL-8216,
> + *          ICP DAS A-821PGH/PGL/PGL-NDA, A-822PGH/PGL, A-823PGH/PGL, A-826PG,
> + *          ICP DAS ISO-813
> + * Author: Michal Dobes <dobes@tesnet.cz>
> + * Devices: [Advantech] PCL-812 (pcl812), PCL-812PG (pcl812pg),
> + * PCL-813 (pcl813), PCL-813B (pcl813b), [ADLink] ACL-8112DG (acl8112dg),
> + * ACL-8112HG (acl8112hg), ACL-8113 (acl-8113), ACL-8216 (acl8216),
> + * [ICP] ISO-813 (iso813), A-821PGH (a821pgh), A-821PGL (a821pgl),
> + * A-821PGL-NDA (a821pclnda), A-822PGH (a822pgh), A-822PGL (a822pgl),
> + * A-823PGH (a823pgh), A-823PGL (a823pgl), A-826PG (a826pg)

Please add extra whitespace (a tab or a couple of spaces) to the
"Devices:" continuation lines here, e.g.:

 * Devices: [Advantech] PCL-812 (pcl812), PCL-812PG (pcl812pg),
 *   PCL-813 (pcl813), PCL-813B (pcl813b), [ADLink] ACL-8112DG (acl8112dg),
 *   ACL-8112HG (acl8112hg), ACL-8113 (acl-8113), ACL-8216 (acl8216),
 *   [ICP] ISO-813 (iso813), A-821PGH (a821pgh), A-821PGL (a821pgl),
 *   A-821PGL-NDA (a821pclnda), A-822PGH (a822pgh), A-822PGL (a822pgl),
 *   A-823PGH (a823pgh), A-823PGL (a823pgl), A-826PG (a826pg)

This extra whitespace is for the benefit of some scripts we have in
comedi and comedilib for extracting the documentation.  (Actually, these
scripts don't handle the " * " at the beginning of the line yet, but I'm
working on that!)

Thanks.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
