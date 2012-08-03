Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2HCTBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:01:15 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:47347 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2HCTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:01:12 -0400
Subject: Re: Linux 3.6-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>
In-Reply-To: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Aug 2012 12:01:01 -0700
Message-ID: <1344020461.6210.20.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good afternoon Linus!

On Thu, 2012-08-02 at 18:17 -0700, Linus Torvalds wrote:
> I do have two more pull requests that are at least tentatively
> pending: there's the uapi header file disintegration from David
> Howells and the tcm_vhost merge from Nicholas Bellinger, both of which
> came in in time. So I'll take another look at those later. 

Thanks for considering to let tcm_vhost fall under the new driver merge
exception rule for post -rc1 code.

Everything is still ready to go on our side for an initial merge, and I
just doubled checked that target-pending/for-linus is still merging
cleanly w/ the same diffstat into a local HEAD at refs/tags/v3.6-rc1.

As usual, please let us know if you have any concerns.

Thank you,

--nab

 












