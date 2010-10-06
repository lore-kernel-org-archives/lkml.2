Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab0JFU4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:56:19 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:46665 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932630Ab0JFU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:56:18 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: VVHi46IVM1kk2W7v4iGHg3xC2uQZavU0Rl7Gw9stUPaUAOL
 bHspmp5ElQx9D48raDzdFwh8rDNY4ErkuGB1raUMZLNCKj7yNqpRuZelIjGj
 5J5pv9Q9b1u7jBPzcJF2xDTcYC_kv1MLrrFvL4JyRJGVQsAISyTL0u2fNC8G
 EwfsR5xbT.O5xGnwbb4Y433aFOVBKvJ8ZwzPrBctwKsnm1Skh_ik.HXYdMq_
 a6DgmKDj0F59v_N4bsVnNQHyOoxAlg31CC_scntoGu5.y
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Oct 2010 15:56:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Kennedy <richard@rsk.demon.co.uk>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Mel Gorman <mel@csn.ul.ie>, npiggin@kernel.dk,
        yanmin_zhang@linux.intel.com
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
In-Reply-To: <1286379979.1897.0.camel@castor.rsk>
Message-ID: <alpine.DEB.2.00.1010061554040.8083@router.home>
References: <20101005185725.088808842@linux.com>  <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>  <4CAC577F.9040401@rsk.demon.co.uk>  <AANLkTikr9B5Yb+Owe3t+Rb8KBO33DE=9YBQZ_1+Gwcu8@mail.gmail.com> <1286379979.1897.0.camel@castor.rsk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Created a unified branch in my slab.git on kernel.org as well. Based on
Pekka's for-next branch. There was an additional conflict caused by
another merge to for-next that was fixed.

git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/slab.git unified


