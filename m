Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2FERjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:39:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47222 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2FERjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:39:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Glauber Costa <glommer@parallels.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        Serge Hallyn <serge.hallyn@canonical.com>, <kir@parallels.com>,
        <Michael@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        <linux-kernel@vger.kernel.org>, Kerrisk <mtk.manpages@gmail.com>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>
In-Reply-To: <4FCDD8A0.1070608@parallels.com> (Glauber Costa's message of
	"Tue, 5 Jun 2012 14:00:00 +0400")
References: <1338816828-25312-1-git-send-email-glommer@parallels.com>
	<4FCDD315.502@free.fr> <4FCDD346.9090008@parallels.com>
	<4FCDD8A0.1070608@parallels.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Tue, 05 Jun 2012 10:39:09 -0700
Message-ID: <87r4tt64le.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19SZpSsU/1oKWZyg/QwFBaRzm0WSGK16mg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Glauber Costa <glommer@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [Devel] Re: [PATCH] allow a task to join a pid namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Eric, what are your plans for merging the content of that tree ?

Hopefully this cycle.

The issue with the pid namespace is primarily that we need to fix
all of the life cycle issues with the pid namespace and make certain
that setns adding an additional pid in a pid namespace does not break
those pid namespace life cycle fixes.

So I have been working on the hard tricky fixes off and on with Oleg.

Eric

