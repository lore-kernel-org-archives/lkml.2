Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1EQOiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:38:06 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:26565 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755161Ab1EQOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:38:05 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Q2ZuNicVM1nP_Zpk9yOYJUbioZTBU4UKmPKALZRt0udxlB5
 sSQTOe80LDBoupgmD9LkYP3lJ3CyPWXGlvYJvybLsdmXe0P3O7QPj6ntVEXx
 RwJcSqrVec1Hao5i215hzzHU3QC8H04O5KN6KvXf1ftecRsFNreXRrlVO2uR
 8h6UWcAvYnKBMH5V3FpCbKkmxQHt6cPlGNOaVF5ES7d3RwSTCUDlohCXCrIu
 ECfIYijfxanA7t2Xu_Yef3HwfARoM0QIKMKuiLSY3_LIUbMuQro7PyeF8E47
 MN1e4Z8NCq1_maKWsU3kJdszdIHPxk6Fj19KQwbMB07rU3USoJnAah.QsZdB
 O9PU1xXHKvvd.4E4Ydv1lezh0
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 May 2011 09:38:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch V3] percpu_counter: scalability works
In-Reply-To: <20110517140233.GP20624@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1105170936440.11187@router.home>
References: <1305609768.2375.84.camel@sli10-conroe> <1305622861.2850.21.camel@edumazet-laptop> <20110517091102.GE20624@htj.dyndns.org> <1305625541.2850.29.camel@edumazet-laptop> <20110517095001.GF20624@htj.dyndns.org> <1305634807.2850.89.camel@edumazet-laptop>
 <20110517124528.GN20624@htj.dyndns.org> <1305637223.2850.95.camel@edumazet-laptop> <20110517130414.GO20624@htj.dyndns.org> <alpine.DEB.2.00.1105170853520.11187@router.home> <20110517140233.GP20624@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Tejun Heo wrote:

> We can implement force-flush for dire situations, similar to expedited
> RCU flush thing.

I would suggest that if the user wants accurate results then another
external form of synchronization needs to be provided. Maybe the counter
is always incremented when another lock has been taken.

