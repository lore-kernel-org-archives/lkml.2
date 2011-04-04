Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1DDUxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:53:05 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38969 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab1DDUxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=Z99blU56UFFLCZ6reOW1Z6VOrOaxnNrMlTlf870BKv/rlOWoBpSAjN+r5kMHaQVKR3
         A9EY+PurwleHhK/fE1VRUhZFOkrqve0CAiC/BXn3B/8VRHPzDIw1hbMYOJyWR5LxSvZZ
         gywv2gGHIRVqfzz77m4FArdVoih2bNPH5E6rY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <c428cc13a1a5953be3310237e4f404ec65968d5a.1301936559.git.joe@perches.com>
References: <664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
	<20110404130036.GB16669@srcf.ucam.org>
	<c428cc13a1a5953be3310237e4f404ec65968d5a.1301936559.git.joe@perches.com>
Date: Mon, 4 Apr 2011 22:53:01 +0200
Message-ID: <BANLkTikCRLX61JUkbbo-g8CeNRf2=RK08Q@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] thinkpad_acpi: Convert printks to pr_<level>
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 7:06 PM, Joe Perches <joe@perches.com> wrote:
> Add pr_fmt.
> Removed local TPACPI_<level> #defines, convert to pr_<level>.
> Neaten dbg_<foo> macros.
> Added a few missing newlines to logging messages.
> Added static inline str_supported for !CONFIG_THINKPAD_ACPI_DEBUG vdbg_printk
> defect reported by Sedat Dilek <sedat.dilek@googlemail.com>.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
