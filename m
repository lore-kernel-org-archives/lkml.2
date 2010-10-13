Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0JMWDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 18:03:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:57713 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab0JMWDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 18:03:09 -0400
Message-ID: <4CB62C92.4060505@suse.cz>
Date: Thu, 14 Oct 2010 00:02:58 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: jk@ozlabs.org, elendil@planet.nl, Gilles Espinasse <g.esp@free.fr>,
        Jiri Kosina <jkosina@suse.cz>,
        John Saalwaechter <saalwaechter@gmail.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/package: don't break if %{_smp_mflags} isn't
 set
References: <1286991585-4099-1-git-send-email-nacc@us.ibm.com>
In-Reply-To: <1286991585-4099-1-git-send-email-nacc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.10.2010 19:39, Nishanth Aravamudan wrote:
> Same fix as in 13797b77d419fc1b16eebf2993bf7b5cea65f0bf is needed for the "new"
> line invoking _smp_mflags for modules_install. Without the fix, `make
> binrpm-pkg` fails with:
> 
> + make '%{_smp_mflags}' KBUILD_SRC= modules_install
> make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
> make[2]: *** No rule to make target `%{_smp_mflags}'.  Stop.
> error: Bad exit status from /var/tmp/rpm-tmp.8S9B9e (%install)
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

Thanks for the fix, applied to kbuild-2.6.git#packaging.

Michal
