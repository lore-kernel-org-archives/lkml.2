Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab2KVTh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:37:57 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57999 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab2KVThh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:37:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121122102710.GD4328@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
	<20121122102710.GD4328@gmail.com>
Date: Thu, 22 Nov 2012 16:00:20 +0530
Message-ID: <CAKohponbF9urMVyerdikCeMy4uKChVKSDXub7nJtH+zFbJ9Qsg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] mfd: stmpe: Use devm_*() routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2012 15:57, Lee Jones <lee.jones@linaro.org> wrote:
> I'm assuming you've reversed the semantics here for >80 chars reasons?

Not for 80 chars reason :)
I did it to decrease nesting level of if/else statements :)

--
viresh
