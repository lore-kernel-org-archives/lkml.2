Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0CWMaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:30:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0CWMau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:30:50 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 1/5] cpufreq: Unify sysfs attribute definition macros
Date: Tue, 23 Mar 2010 13:30:45 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <201003231255.30461.trenn@suse.de> <20100323120534.GE16493@aftab>
In-Reply-To: <20100323120534.GE16493@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231330.45840.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010 13:05:34 Borislav Petkov wrote:
> From: Thomas Renninger <trenn@suse.de>
> Date: Tue, Mar 23, 2010 at 12:55:30PM +0100
> 
> > > Well, struct freq_attr for example is cpufreq-specific attribute,
> > > AFAICT. So, keeping them in cpufreq.h should be fine, no?
> > You don't need much of these (one or two?).
> 
> I don't think I get what you mean here..?
I expect you did this because you use it in your follow up patches, e.g.
+define_one_freq_rw(cpb);
If you don't want to argue about global names, but get your boost code
in quickly, just also duplicate the macro and if you have some time left
you could still do an on-top cleanup later.

   Thomas
