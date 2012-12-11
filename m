Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2LKS3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:29:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38448 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2LKS3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:29:31 -0500
Date: Tue, 11 Dec 2012 18:29:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/2] ima: policy search speedup
Message-ID: <20121211182922.GL4939@ZenIV.linux.org.uk>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
 <1355234914.2356.85.camel@falcor>
 <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
 <CALLzPKZQ3=qNOxJk-yqDGEzqkcKLoc9tPPD8o9QbJOUOB1nWuQ@mail.gmail.com>
 <CA+55aFxh2SH9WcXbb+hD3PtWa4ZTqYNUxvbqZh27vwANuUTE8w@mail.gmail.com>
 <CALLzPKYGUK3XzNZQ76fD7-PMK88TK1L8xowiKnco2JPUVw1k8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKYGUK3XzNZQ76fD7-PMK88TK1L8xowiKnco2JPUVw1k8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:10:07PM +0200, Kasatkin, Dmitry wrote:

> I was suggesting to add a flag for sb->s_flags field.
> Al said that he would not like this, because s_flags are mount specific.

s/mount-specific/in an incestous relationship with mount(2) ABI/.
