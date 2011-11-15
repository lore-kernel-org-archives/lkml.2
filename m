Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1KOPwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:52:01 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:48611 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756450Ab1KOPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:52:00 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iwPbl8IVM1nue_.b9hdDeAkUBOTi2TnRiRc3IdXM_HV0SQ6
 wOIhXNjmOmPyCYvbtCwy03oQlhcruVam13LYTAQEI1RhFKlqAL2ZJeIaQZcT
 73uhaohsf3yLJE9J0OTumeRyj_MTad5gXYPr.8BeY2eOZjal7fH0I9bHOzWt
 0ClmaMG4igDrMFVwGj9vVnUifJJV4g5GOSK_DOYokeDNS2JuG3SklWJY2lEH
 fZkHEQiMpfXGWd2sU4HeWG3.1UQbWSDo95zYh_qcENnK_WgExXq3iXHOrKui
 kRqGHqIyW6ea9f4_FNOISMAfPSLTfgPwTpjHUnU4MyhimOrj1ceOZKUUo9Wk
 68vtuvBwZ.YNFQLbque860steUPuN4xxfR5QsLsJvbjg.hCwrbg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 15 Nov 2011 09:51:56 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 1/5] smp: Introduce a generic on_each_cpu_mask
 function
In-Reply-To: <1321179449-6675-2-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1111150951140.22502@router.home>
References: <1321179449-6675-1-git-send-email-gilad@benyossef.com> <1321179449-6675-2-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Nov 2011, Gilad Ben-Yossef wrote:

> on_each_cpu_mask calls a function on processors specified my cpumask,
> which may include the local processor.

Reviewed-by: Christoph Lameter <cl@linux.com>
