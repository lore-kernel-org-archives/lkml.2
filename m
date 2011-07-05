Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1GEWsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:48:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33433 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1GEWsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <62528.1309905474@turing-police.cc.vt.edu>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
	<1309571259-15241-1-git-send-email-lacombar@gmail.com>
	<1309571259-15241-4-git-send-email-lacombar@gmail.com>
	<62528.1309905474@turing-police.cc.vt.edu>
Date: Tue, 5 Jul 2011 18:48:00 -0400
Message-ID: <CACqU3MWxCNKnj39iyXeTOXgFvs_fx+dd6gUW4LFVUu+jH5KgkA@mail.gmail.com>
Subject: Re: [RFC 3/7] kconfig/check.sh: prepare for generic check
From: Arnaud Lacombe <lacombar@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 5, 2011 at 6:37 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 01 Jul 2011 21:47:35 EDT, Arnaud Lacombe said:
>
>> diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
>
> Can this be check_libs.sh or similar, to better indicate the function?
>
Definitively. I was tempted at some point to call it configure.sh and
to rename the .tmp_check to .config.mk as it generates host-specific
config for the main Makefile. I finally went the path of least
modification.

 - Arnaud
