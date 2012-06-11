Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab2FKPFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:05:52 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:30847 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755597Ab2FKPFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:05:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Dan.qJUVM1n0jjNpCRmkcC6cBTZW2hkv.S77iAtAxUiKBGJ
 cu1k8id.fX1YWu3xlsdqsftM4KDihdxDgVCzEaZgWL67opLNJFKTNQNm2t56
 nvi.5PugaqjNPzsg3KJ4S2uKlWQTsucD.FphiuCsdrkmDLIW0qXgfTjrTNLH
 zBLuB8S5WiPUu5vbxQ9Q6TgGvyWL9tRQcS9odxed58sJK1pZCn81FaCY2Zd5
 Idjy4nSnu8FcST3265IxfmO6s54w5N8cBrAN4vUn5y_6Bc0TBpeQNWWfvFTx
 XW3Z3kp2r_6My0td2eQ4522TVE5Lw0Mh3JQoV.9u4yMio_H0rMzNa5eHRXqz
 FxXakPnfRqP9HD27qpIQdyxrP4fjIC0jXzjEx6Bg7uEpdErGDOhOfw3uW15I
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 11 Jun 2012 10:05:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Mackey <tdmackey@twitter.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
        Andi Kleen <ak@linux.intel.com>, penberg@kernel.org
Subject: Re: [PATCH v5] slab/mempolicy: always use local policy from interrupt
 context
In-Reply-To: <1339234803-21106-1-git-send-email-tdmackey@twitter.com>
Message-ID: <alpine.DEB.2.00.1206111005290.1168@router.home>
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org> <1339234803-21106-1-git-send-email-tdmackey@twitter.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2012, David Mackey wrote:

> I believe the original mempolicy code did that in fact,
> so it's likely a regression.

Acked-by: Christoph Lameter <cl@linux.com>
