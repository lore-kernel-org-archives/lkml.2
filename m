Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2GPRhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:37:20 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:32832 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752657Ab2GPRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:37:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Q1dZ4_cVM1nw9kpn.9nH7WfHPZ2rqVLVOT_u.koOh1Z2rHV
 Cxuj.SLQqTlNeBwpbxOaMCaXMn3SCS6UIeInAN0ZJviMZPi_Yhp.Zcdg2_Ud
 Shspz.th5wxpXlARzLKXUWbOXMbGPW4e6SI0EVXgq8NyFv3V0HqLeGTVJuoJ
 uqBgTbBgB_rbQdBg3aS0sVFY16kl6yZDYfqJXhEQOlY_jMQxMNLGDDnopveO
 Yh1vtkm6Fvk6RutwEovsAdV01bff.pzQjfxruZyGipEoDB9kWAzUD6J8r5i7
 XcEzftXZZdERU5rMsYAOZvvfkIp5SGHgHj9egBHMT5VmPgo.DSQsaKbL3jZg
 BNrzKN09aMtbQ9MtwEtcqqt0Ag33lHrBHPlzbap98vRBWJUPxtczc7BH7osA
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 16 Jul 2012 12:37:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: correct return value of migrate_pages()
In-Reply-To: <CAAmzW4P0Pa5-gM7mDnqBXCC=g3zk-z_7pXbR7XPM6Tv6CcVJiw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207161237060.32319@router.home>
References: <1342455272-32703-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207161220440.32319@router.home> <CAAmzW4P0Pa5-gM7mDnqBXCC=g3zk-z_7pXbR7XPM6Tv6CcVJiw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, JoonSoo Kim wrote:

>
>         for (pass = 0; pass < 10 && retry; pass++) {
>                 retry = 0;
> +               nr_failed = 0;
>
>                 list_for_each_entry_safe(page, page2, from, lru) {
>                         cond_resched();
>
> When I resend with this, could I include "Acked-by: Christoph Lameter
> <cl@linux.com>"?

Sure.

