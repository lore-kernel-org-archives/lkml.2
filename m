Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab2IMSXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:23:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60142 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2IMSXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:23:36 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Thu, 13 Sep 2012 20:27:21 +0200
Message-ID: <3388232.NZrhE7HLxb@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.3-1.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20120913114531.4560b3f0@lwn.net>
References: <1347544368-30583-1-git-send-email-federico.vaga@gmail.com> <2107949.TNqhOsq2WF@harkonnen> <20120913114531.4560b3f0@lwn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data giovedì 13 settembre 2012 11:45:31, Jonathan Corbet ha scritto:
> On Thu, 13 Sep 2012 17:46:32 +0200
> 
> Federico Vaga <federico.vaga@gmail.com> wrote:
> > > A few words explaining why this memory handling module is required
> > > or
> > > beneficial will definitely improve the commit :)
> > 
> > ok, I will write some lines
> 
> In general, all of these patches need *much* better changelogs (i.e.
> they need changelogs).  What are you doing, and *why* are you doing
> it?  The future will want to know.

I can improve the comment about the ADV7180: it is not clear why I'm 
removing that functions. (and the memory allocator commit is also in the 
todo list).

The STA2X11_VIP commit, I think is clear, I convert it to use videobu2 
and control framework. I can add some extra lines to explain why: 
because videobuf is obsolete

> I'm going to try to look at the actual code, but time isn't something
> I have a lot of, still...

The actual code is the same of the previous one with yours (plural) 
suggestions from the RFC submission (few week ago). I did not write 
anything else.

-- 
Federico Vaga
