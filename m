Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab1JDTme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:42:34 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:20307 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933417Ab1JDTmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:42:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VK.63zIVM1npOlUUasBE99E2lHm2RSn75X3cBXp1BQQ2GEB
 m6yCqPvAOUiXXekii5b5DNEMYzVs_gL.h9j7QYym48_ZPSWTB8rnqMyhrbDZ
 nqlc2TZMDweuFxoAJD1Pr_B0gRDjNJ3aDl1NceZ9b8Vp0xNfTAQ1zMZusgEV
 FnOqGyPX2yBR0jUwB4MVtHbHEinchq9nQ2Ufm0TkjJdc.mTxFZeaoOJj6n5F
 HqEQRsQd_mkL71jeBtQXCLpr1c7CItlUJW33RV.GhnaHBdqeNoyAvoh5zeQy
 tGHf1QEptEG9u3WQpsObPYGOnOPwM_fKqwP0PNsGiTiNpWjMqaKENdxzm7Yk
 .1qlfAfy7kf8hJtHOg4DRJYtfqwg6rmpqOK1cVhsluClHCZOsRwpbOi6Zs2f
 Pz_hM_xdVNBHRL9YpcgdbsA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 4 Oct 2011 14:42:28 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Joe Perches <joe@perches.com>
cc: starlight@binnacle.cx, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: Re: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
In-Reply-To: <1317757118.3580.24.camel@Joe-Laptop>
Message-ID: <alpine.DEB.2.00.1110041442020.15871@router.home>
References: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx>  <alpine.DEB.2.00.1110041358500.12199@router.home> <1317757118.3580.24.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Oct 2011, Joe Perches wrote:

> Idly curious, have you compared bfs performance?

No. BFS has no NUMA support.


