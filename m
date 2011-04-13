Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab1DMOI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:08:59 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:27981 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753556Ab1DMOI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:08:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: iGbeeeEVM1kP5kWJj8ryEEiLvX3i4rbf4TG2jLwX.VJMdTS
 7o0KfYYTr4g4c4.CGsmL5IonU8g4QFkmTeUamOiTTEQSbV_jiHNC0c2vkQd_
 pdVzA1NTXxItC7n2dlw29CXh6ilXofEGub99OzFqURfbjCIo8ykW.LylyIWW
 _C_SLqI.U3VXTIvbcQm7Nzt4YQp3aa2_RCODH5ibeh4NSqAwbQwSnBpBqodL
 hgCp92f6zL4UGnTqG73a9S2.tQf1mFgM3nNawq8Sj8.rlvmu1uwEmmDfgCX2
 mx.OLm1zsRBLOIsAeXqB0PCfRn2ABl6jgkNQgz1HParqwhyQy
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Apr 2011 09:08:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: shaohua.li@intel.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [patch v2 0/4] percpu_counter: cleanup and fix
In-Reply-To: <20110413075715.090406229@sli10-conroe.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1104130907480.16214@router.home>
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, shaohua.li@intel.com wrote:

> Cleanup percpu_counter code and fix some bugs. The main purpose is to convert
> percpu_counter to use atomic64, which is useful for workloads which cause
> percpu_counter->lock contented. In a workload I tested, the atomic method is
> 50x faster (please see patch 4 for detail).

Could you post your test and the results please?

