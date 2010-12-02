Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0LBDVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 22:21:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20536 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0LBDVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 22:21:46 -0500
Message-ID: <4CF7108E.6020701@oracle.com>
Date: Wed, 01 Dec 2010 19:20:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>
Subject: Re: linux-next: manual merge of the staging tree with the staging.current
 tree
References: <20101202132254.93e019c7.sfr@canb.auug.org.au>
In-Reply-To: <20101202132254.93e019c7.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/10 18:22, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/winbond/sysdef.h between commit
> 412dc7f368bf10a8049a8a4c41abbfd0108742e7 ("staging: fix winbond build,
> needs delay.h") from the staging.current tree and commit
> ddee7e28e7d5e4ba2b8537c6a59b035745c250bb ("Staging: w35und: Remove empty
> sysdef.h header") from the staging tree.
> 
> I removed the file.  I wonder if
> drivers/staging/winbond/phy_calibration.c and
> drivers/staging/winbond/reg.c now need their own includes of
> linux/delay.h ...

Probably, since sysdef.h was no longer an empty file.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
