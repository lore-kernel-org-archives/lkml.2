Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1G1NrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:47:06 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:24959 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755303Ab1G1NrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:47:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6c620c8VM1l3aA2cV_1SqZ4rRs3pJuGIt7Tc6AE1TJkdL5I
 SiQ0kpHZ1CNyLZKfsHINCfPlnNhmxZRqg9vXwOeoDwLsHGJiIIPaUxw3k4P4
 TMnDSW70x8XROHAIhmgZkPfhP64M_jXJ4IcBanZR.PlTF_q30o4PeavbzD6v
 fjzVPJFkLpnrZ09SYsjhOqXE8Hht2WmRzX9GV33kUOG2PIHA6pC4wz6dT_AR
 wzAVmMhFP.pr0SvOV1Mp8EX3c5N_yScFx2MlezXP1CkXfEZc7mHGfEho4Amc
 Ge5kP6NFq_dcpFUGiyhRLt4695ZbBPRSUF0QYq5n27fH650pp
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 28 Jul 2011 08:47:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [GIT PULL] SLAB changes for v3.1-rc0
In-Reply-To: <CAOJsxLHniS9Hx+ep_i2qbE_Oo6PnkNCK5dNARW5egg9Bso4Ovg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1107280846300.12379@router.home>
References: <alpine.DEB.2.00.1107221108190.2996@tiger> <CAOJsxLHniS9Hx+ep_i2qbE_Oo6PnkNCK5dNARW5egg9Bso4Ovg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Pekka Enberg wrote:

> On Fri, Jul 22, 2011 at 11:08 AM, Pekka Enberg <penberg@kernel.org> wrote:
> > Please note that the SLUB lockless slowpath patches will be sent in a
> > separate pull request.
>
> Christoph, your debugging fix has been in linux-next for few days now
> and no problem have been reported. I'm considering sending the series
> to Linus. What do you think?

Do not know of any other new issues so ok.

