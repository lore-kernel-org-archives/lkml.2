Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2FVQGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:06:02 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44257 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab2FVQGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <1340379615.11290.1.camel@lappy>
References: <1340379615.11290.1.camel@lappy>
Date: Sat, 23 Jun 2012 00:06:00 +0800
Message-ID: <CACVXFVOsuRLrcA4x0yVdQVdPD-qqF6eEaUn0A++H3LEG1hLZoA@mail.gmail.com>
Subject: Re: RCU hangs in latest linux-next
From: Ming Lei <tom.leiming@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: paulmck <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 11:40 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Hi Paul,
>
> The following tends to happen quite often when I run the trinity fuzzer on a KVM tools guest using latest linux-next:

I observed it too, with no special operation after kernel booting.


Thanks,
-- 
Ming Lei
