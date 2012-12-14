Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2LNQIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:08:21 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:27845 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab2LNQIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:08:16 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2012 11:08:16 EST
X-RZG-AUTH: :JmkKe0mufu3CxrePViMusPB/RF9xXhaaYyrlzjsV61yypLP1nVvbwmdl8puK
X-RZG-CLASS-ID: mo05
Message-ID: <50CB5B12.4040105@informatik.stud.uni-erlangen.de>
Date: Fri, 14 Dec 2012 18:00:02 +0100
From: Jennifer Naumann 
	<Jennifer.Naumann@informatik.stud.uni-erlangen.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: Sebastian Hahn <snsehahn@cip.cs.fau.de>, dan.carpenter@oracle.com,
        standby24x7@gmail.com, Julia.Lawall@lip6.fr, jkosina@suse.cz,
        joe@perches.com, yongjun_wei@trendmicro.com.cn,
        adam.buchbinder@gmail.com, amwang@redhat.com, justinmattock@gmail.com,
        wfp5p@virginia.edu, jim.cromie@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Jennifer.Naumann@informatik.stud.uni-erlangen.de
Subject: Re: [PATCH 0/6] staging:rtl8192u: begin cleanup of some checkpatch
 errors
References: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
In-Reply-To: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 09:40 PM, Sebastian Hahn wrote:
> Jennifer and I have started making the rtl8192u driver conform with the
> CodingStyle rules a little better. We started out with a cleanfile run,
> then did corrections for individual issues, grouped into patches by
> specific issue fixed.

Thanks for the feedback we've received so far, is there anything else we
need to do from here? We've verified the series still applies to the
current staging-next tree and would be happy to further improve the
patches as necessary.

Regards,
Jennifer Naumann
