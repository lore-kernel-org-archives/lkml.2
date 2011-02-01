Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1BAWwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:52:16 -0500
Received: from smtp-out.google.com ([74.125.121.67]:23482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1BAWwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:52:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XTDgCenBMbou9YSE0xilFSeU64zsKzBHwyTzXDS2f7IsNPeFwAar+uJPJ2pE3RAEMO
         QP/I31f71dzB6PhfSoow==
MIME-Version: 1.0
In-Reply-To: <201102011002.09819.jordipujolp@gmail.com>
References: <201102011002.09819.jordipujolp@gmail.com>
From: Paul Menage <menage@google.com>
Date: Tue, 1 Feb 2011 14:44:56 -0800
Message-ID: <AANLkTineUvbe4w53zVEyfafs_ERt1NPbRo83KeAH89KF@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] cgroup: enable write permission for the group of users
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 1:02 AM, Jordi Pujol <jordipujolp@gmail.com> wrote:
> Hello,
>
> Working in a development that uses control groups and libcgroup, I have found
> that the files in control groups directories need write permission for the
> group of users also.

This can be configured from userspace - chmod() works just fine on
control files in cgroupfs.

Paul
