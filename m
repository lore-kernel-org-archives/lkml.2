Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0JPVLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 17:11:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57159 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0JPVLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 17:11:33 -0400
X-User-Agent: K-9 Mail for Android
References: <20101016065206.GO4681@dastard> <20101016192027.GA6883@infradead.org>
In-Reply-To: <20101016192027.GA6883@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 16 Oct 2010 14:10:29 -0700
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, devel@lists.fedoraprojet.org
Message-ID: <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm confused ... what makes you think we are?  This might have been an unintentional misconfiguration...

"Christoph Hellwig" <hch@infradead.org> wrote:

>Besides the algorithmic problems with ima, why is kernel.org using
>IMA to start with?  Except for IBM looking for a reason to jusity why
>TPM isn't a completely waster of ressources it's pointless.  And it was
>only merged under the premise that it would not affect innocent normal
>users.
>

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
