Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1BDVdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:33:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33751 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1BDVdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eCbJ+pYSSF+EOnNozJHHepEx/VStR3K8bweshBxaJrNeetaB47iQwmlGO3UcvwUznC
         1WOmv2KCOgXH/MHpBde0iYLREhH6Wq4c8H1WL2xSiwZe93Sdn1wAMOSEeVbxu3ec6n6p
         kAVMAFcUB8YfaB152ErToU9c9jaljkzOU7BaE=
MIME-Version: 1.0
In-Reply-To: <m11v3nik19.fsf@fess.ebiederm.org>
References: <1296851935-6909-1-git-send-email-lucian.grijincu@gmail.com> <m11v3nik19.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Fri, 4 Feb 2011 23:30:51 +0200
Message-ID: <AANLkTinu6fdoJsqov1ucsMH2nnSCghtX+YOFSHsv=u2_@mail.gmail.com>
Subject: Re: [PATCH] sysctl: fix binary sysctl overflow
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 4, 2011 at 11:09 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> I think the maximum depth of this table is only about 6, but
> feel free to count and tell me CTL_MAXNAME is set too low.


Oh, you are right, after reading the code a bit more attentive I see
that the check was right from the start :)

Kids, don't drink and submit kernel patches :P

-- 
 .
..: Lucian
