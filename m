Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab2EUNju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:39:50 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:34221 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2EUNjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:39:49 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Richard Davies <richard.davies@elastichosts.com>,
        Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Minchan Kim <minchan.kim@gmail.com>
Date: Mon, 21 May 2012 09:39:29 -0400
Subject: RE: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Topic: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Index: Ac03IRZvfJRTsViRRWqmMuud96sxbwANcwEQ
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C015955EED7@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com>
 <20120424082019.GA18395@alpha.arachsys.com>
 <65795E11DBF1E645A09CEC7EAEE94B9C014649EC4D@USINDEVS02.corp.hds.com>
 <20120426142643.GA18863@alpha.arachsys.com>
 <CAHGf_=pcmFrWjfW3eQi_AiemQEm_e=gBZ24s+Hiythmd=J9EUQ@mail.gmail.com>
 <4FA82C11.2030805@redhat.com> <20120521071226.GJ29495@alpha.arachsys.com>
In-Reply-To: <20120521071226.GJ29495@alpha.arachsys.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1205210123
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 05/21/2012 03:12 AM, Richard Davies wrote:
> Now that 3.4 is out with Rik's fixes, I'm keen to start testing with 
> and without this extra patch.
> 
> Satoru - should I just apply your original patch (most likely), or do 
> you need to update for the final released kernel?

Thank you for testing!
I believe you can apply the patch without any updates.

Regards,
Satoru
