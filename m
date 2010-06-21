Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab0FUTKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:10:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab0FUTKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:10:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Tiago Maluta <tiago.maluta@gmail.com>, linux-kernel@vger.kernel.org,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
In-Reply-To: Andrew Morton's message of  Monday, 21 June 2010 12:06:13 -0700 <20100621120613.86cad1a4.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
	<20100621120613.86cad1a4.akpm@linux-foundation.org>
X-Windows: a moment of convenience, a lifetime of regret.
Message-Id: <20100621190956.5C9AC400C5@magilla.sf.frob.com>
Date: Mon, 21 Jun 2010 12:09:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps the "%"=% thing isn't supported with your version of make(1). 
> Which version are you using?

There isn't a version of make capable of doing kbuild at all
that doesn't support that syntax.

> Directly grepping .config probably isn't the right thing to do. 
> Maybe `patsubst' can be used here.

The :"%"=% syntax is the same as patsubst.


Thanks,
Roland
