Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab1CaPEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:04:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58240 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1CaPEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Omi7rsafHiP1wkN9Ix3dKtDTpVmmPC1opaB5YFw8oiW2Q47V6vI+R8XRU5pI4OxuA7
         nQBzxsRNbFwHQ7JgiytwhQCq0mBih8xr9SBzMiSL0kjFgjKvar2XpJ2TPNVv/8zFWkTc
         fKWcxdoY9bM0BXrqaXLocy6WB0Fr/SzP48srA=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, jeffm@suse.com
Subject: Re: Reiserfs deadlock in 2.6.36
Date: Thu, 31 Mar 2011 17:04:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201011181650.00152.roucaries.bastien@gmail.com> <AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com> <AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
In-Reply-To: <AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103311704.40372.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 mars 2011 11:14:28, Bastien ROUCARIES a écrit :
> On Tue, Mar 8, 2011 at 4:22 PM, Bastien ROUCARIES
> 
> <roucaries.bastien@gmail.com> wrote:
> > On Tue, Mar 8, 2011 at 3:18 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> On Sun, Jan 30, 2011 at 01:08:29AM +0100, Bastien ROUCARIES wrote:
> >>> Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
> >>> Hi,
> >>> 
> >>> I take me more than two days of testing to reporduce this bugs with
> >>> trace enabled. My filesystem was quite slow and this bugs seems to be
> >>> timing related.
> 
> Any news of this bug? Could I do something to help ?
> 
> bastien
> 
> > Ok bastien
