Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1J0Cbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 22:31:52 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:43760 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751507Ab1J0Cbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 22:31:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MP2AscsVM1kTY3gwtwz9jA1NZgLo2hny1WijYN.KJlwQlty
 6WKEcVSnA0ONQvtnPXDxlDGzcsLZqg2Q3Fjh.tpevcPV5TiAfUY78GLtbIrR
 0G.0q4mIAmIOABu082c.wBTPFVq3p2rOBeT4dXZzbaklx88eDIhJ_aZ0oJAB
 y_liIy23MlqaOhP5TEy_gVBNUpbNPTaflswQT1UFCG8RDtzR0Kake6ujW1Hg
 tKyznIhuq0PObc3eCcJUsEr602tCFsA75_s2Tc5T12wKtG8cRo7MIxyWT_Zk
 bWdfipxfqy8Is0HrxEScT9VDRv.61DFMYtUnyEZo9xx6T5Hk9_gftC9V723j
 cmK6GBmpxLEnFFuykrYLgeY52TEiZK3S2GvNbaV85_EFDCglkyfr2aGtnAAL
 pXABqb0WOcVa.gkTfdaRTvKioGbkkKwkH075KqJPx
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 26 Oct 2011 21:31:46 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Dimitri Sivanich <sivanich@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] cache align vm_stat
In-Reply-To: <20111024161035.GA19820@sgi.com>
Message-ID: <alpine.DEB.2.00.1110262131240.27107@router.home>
References: <20111024161035.GA19820@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011, Dimitri Sivanich wrote:

> Avoid false sharing of the vm_stat array.

Acked-by: Christoph Lameter <cl@gentwo.org>
