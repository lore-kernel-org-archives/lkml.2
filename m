Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1CQRqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:46:25 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:47272 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751576Ab1CQRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:46:23 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: W3WjOxAVM1mY672z3PxRNcytRo8cwUymFVETRNf5v5sqw5j
 6f_bhTZgv9FATLecHlcn8Y5V.tvZwVBA4YkKcWyfOn_w4AvmwPsDFJnV2uP9
 agNvgf2wwynV7vpGoO3NTnxUJ6AnpV9PZ0zFtLX7TuEO0ZG6dwzzgm46dgZT
 79o30UVyxQFLNNTD8ijlxK5N9DUq6UAXZJMatIrvcqIpv5OGYLK._Ipi9bhO
 cf3embovQ37laCa4WtxI.y7pgMZapf0HPX3iC1_632TE1twRhW6WE56mTnHg
 LJ5vssUSSujZAVESPNEQEa3qFnknBDFrYafy5H_fkC6u.VMiM
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 17 Mar 2011 12:46:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Poll about irqsafe_cpu_add and others
In-Reply-To: <1300380801.6315.306.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103171245430.16620@router.home>
References: <1300371834.6315.93.camel@edumazet-laptop>  <20110317.081420.71114992.davem@davemloft.net>  <alpine.DEB.2.00.1103171016270.12540@router.home> <1300380801.6315.306.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Eric Dumazet wrote:

> When we know we run from BH context, we can use __this_cpu_inc(), but if
> we dont know or run from user/process context, we would need irqsafe_inc
> variant.

If the BH context is the only one where we care about performance then its
ok I would think.
