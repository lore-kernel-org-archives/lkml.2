Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1LAQHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:07:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40126 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab1LAQHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:07:48 -0500
MIME-Version: 1.0
In-Reply-To: <20111201155330.GV14515@moon>
References: <20111129191252.769160532@openvz.org>
	<20111129191638.835932727@openvz.org>
	<20111130140009.1ccd5af0.kamezawa.hiroyu@jp.fujitsu.com>
	<20111130060537.GK1775@moon>
	<20111201095434.GR14515@moon>
	<20111201154357.GA12668@google.com>
	<20111201155330.GV14515@moon>
Date: Thu, 1 Dec 2011 08:07:46 -0800
X-Google-Sender-Auth: S_V5BmM1nwh6eRbYtrgqmJ9W5wo
Message-ID: <CAOS58YMScsO5jXcqj9QmxeTCnhmbpjHs7a_QHxTgWPrKy_qz=A@mail.gmail.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 1, 2011 at 7:53 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Hi Tejun, indeed this is not pleasant limit, thanks for the point,
> I'll update! But other than this technical detail, I assume there is
> no objection from introducing such feature?

Nope, I don't have any objection. Thanks.

-- 
tejun
