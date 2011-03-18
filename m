Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1CRSzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:55:40 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59959 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab1CRSze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CsI+NQ5BdpdbldTmoRUEf+6UT9wYuLAQixnVjUXQeblLpdqeTYn4dYOfylEMwS3Do1
         p96+ehudU2oSvlYULou6Viu9g40Y6i9nFufR2/ypEAq5QCnhVaFe/j74LCumKSmaFq98
         U7BeRBqloB/Ropglab/TkJTZxBQDAMncRhg9A=
MIME-Version: 1.0
In-Reply-To: <20110318184957.GA6979@infradead.org>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
	<AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
	<20110317072344.GZ22723@ZenIV.linux.org.uk>
	<AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
	<4d83a82032021e2997@agluck-desktop.sc.intel.com>
	<20110318184957.GA6979@infradead.org>
Date: Fri, 18 Mar 2011 11:55:32 -0700
Message-ID: <AANLkTiky==VxCRcw=0TLH2Ojhgu8k_wfRA-+NNOsMTt9@mail.gmail.com>
Subject: Re: pstore: fix leaking ->i_private
From: Tony Luck <tony.luck@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 11:49 AM, Christoph Hellwig <hch@infradead.org> wrote:
>  - the kmsg_bytes attribute really should be a mount option.  no need
>   have this in a completely different namespace, and require all the
>   kobject mess around it.

Sounds cleaner - I'll take a look.

Thanks

-Tony
