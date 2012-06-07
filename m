Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2FGPfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:35:32 -0400
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:38282 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752624Ab2FGPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:35:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
 <CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
 <CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com> <CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Thu, 7 Jun 2012 08:35:05 -0700
Message-ID: <CAL1RGDXotXpZXUeR6JGu=qAkJE3H8iJ_0A0fQTCXrBJkWJDBRA@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Brian Gitonga Marete <marete@toshnix.com>,
        LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Update your libdrm to libdrm from git should fix your issue.

That's unfortunate -- it means a kernel change breaks working userspace?
