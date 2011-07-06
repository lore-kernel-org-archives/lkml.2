Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1GFLZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:25:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50881 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1GFLZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:25:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110629191615.GA9343@albatros>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
	<20110621153102.762557f3.akpm@linux-foundation.org>
	<20110622064545.GA3605@albatros>
	<20110629191615.GA9343@albatros>
Date: Wed, 6 Jul 2011 14:25:33 +0300
Message-ID: <CACVxJT-R-+Nji5Cu_by1phJSSor_fT2_Pwtn24vpK49PZ_LHEg@mail.gmail.com>
Subject: Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount options
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:16 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>>     mount -t proc -o "pid_allow=exe,status,comm,oom_*" proc /proc
>
> Does this scheme make sense?  Should I rensend the patch with these
> architecture?
>
> pid_allow=, tid_allow=, attr_allow= and watch_gid= or smth like that.

Wildcards are scary, can we please not do them from the beginning.
