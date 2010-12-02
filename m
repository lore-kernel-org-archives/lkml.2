Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab0LBUxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:53:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51971 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0LBUxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=IY7NWDIKmUNEhAplqBeWTmEuYjtDu9mEgHckPxNlDRbgwVtL81fCihrWy17cLPBlar
         KG7JvVAfvyNKhMwzt0Dw==
MIME-Version: 1.0
In-Reply-To: <20101202124559.0a7128de@jacob-laptop>
References: <1291230012-9536-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1291230012-9536-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <AANLkTi=1uv-+Y5t85tyHKk91nJyAKNg5V4Fk2HTJ+ASS@mail.gmail.com> <20101202124559.0a7128de@jacob-laptop>
From: Paul Menage <menage@google.com>
Date: Thu, 2 Dec 2010 12:52:36 -0800
Message-ID: <AANLkTimRrSjJDAxS2Pe5bfMbR=nuV6WQiJdnawSb_kZd@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] cgroup: add per cgroup timer_slack_ns
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: container cgroup <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 12:45 PM, jacob pan
<jacob.jun.pan@linux.intel.com> wrote:
>
> I guess timer_slack_ns alone cannot qualify for a new subsystem,

I think that it's providing a sufficiently different control from
existing subsystems that making it a separate subsystem is reasonable.
The cpuset subsystem definitely doesn't sound like the right place,
since it's more dealing with numa isolation/policy. The cpu subsystem
could be, since it also deals with scheduling stuff.

Paul
