Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab0GMFAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:00:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50541 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0GMFAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QfA8yFdkbK7YPW7LgCdOGsxttmRIDr5tVG/oTCKotHhEsxaU6t9Rvm00Z/2hTHJlOg
         CgImp8sg/+UnDzaRvmGlQ7OnKSaxAn3AdlZ0d/LljWND0NzTBbU2AFGRV+KBcIlKoHr2
         F1VwhYMIiFlLD2yuybVhDtDqSCypaMbDjHWkA=
MIME-Version: 1.0
In-Reply-To: <DA64905D-C83B-4CF5-9405-65F7F82F9563@dilger.ca>
References: <871vbax86w.fsf@patl.com>
	<87zkxyvtjt.fsf@patl.com>
	<3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
	<AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
	<DA64905D-C83B-4CF5-9405-65F7F82F9563@dilger.ca>
Date: Mon, 12 Jul 2010 22:00:10 -0700
Message-ID: <AANLkTinsQjWD1t1lO_BHnM-afzYyl7TKKdIcNZEVMg6n@mail.gmail.com>
Subject: Re: [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes to mount
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 9:46 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2010-07-12, at 19:08, Patrick J. LoPresti wrote:
>>
>> Are you suggesting I need to do this before my patch is accepted at
>> all?  Or is this a refactoring that can happen later?
>
> I'm just suggesting it should be done at some point.  I thought it would be better to do it first, rather than add yet another copy of this code.  That said, I hate to block useful fixes because of cleanup (and I have no control over OCFS2 anyway :-).  However, I've found that once the fix is in people usually forget (or become too busy) to do the cleanup and it just lingers on unseen.

I hear you.

I do not object to factoring out the basic addressability test and
using it in my patch, leaving it for others -- like yourself :-) -- to
modify other file systems to invoke it.

Does that sound like a reasonable compromise?  If so, where should the
function live and what should it be called, do you think?

 - Pat
