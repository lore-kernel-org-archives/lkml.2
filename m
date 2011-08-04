Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1HDP0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:26:50 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:47418 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751856Ab1HDP0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:26:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sKN1UrcVM1kvNQqV8h61LAEmSRLF5y6uYv4aBt0Nao2HVVL
 wfFYla79WLxrhOT5u4cm0Zb6qXpHFtMkmz980VuYteiXChdZbn27cVnjPRIS
 fX_YavXq.dxFuhdXWKUZQYPCIccbnTqmjxToLS33UIHPhAOv2NbYOo7a7SR1
 g.BGjQgLNwtnW8aDccAXqYqQi8IfP8u1xoDLC26dHyt7e1KEz.M.Zf_5.Wza
 W1axIh7qo1Tm4v.kg_j0pnqD4aF9PCJjVxj31JboVkGgd4qigCT_8SynzWyx
 U9GZ33u0vr8hqxeAMBQkIr.mx0u..BpoJrqkRPS7VGR3HSmRgAgY6AQu59Va
 RFcs0lHFqWYh6H_N0acj9Xk8T60E_ZNwdVes-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 4 Aug 2011 10:26:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [listll] Fix fetching of head->first in lockless lists.
In-Reply-To: <alpine.DEB.2.00.1108041021250.24277@router.home>
Message-ID: <alpine.DEB.2.00.1108041026180.24277@router.home>
References: <alpine.DEB.2.00.1108040942360.24277@router.home> <20110804151725.GA21597@Krystal> <alpine.DEB.2.00.1108041021250.24277@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Argh. I see it now. Missed the assignment in the while condition.

