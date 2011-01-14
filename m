Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab1ANLMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 06:12:38 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:35783 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951Ab1ANLMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:12:32 -0500
Message-ID: <4D302F95.9010103@st.com>
Date: Fri, 14 Jan 2011 16:42:21 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jack Stone <jwjstone@fastmail.fm>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs/eventpoll.c: fix compilation warning
References: <1294989352-2003-1-git-send-email-viresh.kumar@st.com> <2426ea8f-7e52-4329-bf20-884c2b996f98@email.android.com> <4D30198D.9080206@st.com> <4D302B92.902@fastmail.fm>
In-Reply-To: <4D302B92.902@fastmail.fm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 04:25 PM, Jack Stone wrote:
> I meant something like
> -  long slack;
> +  long uninitialized_var(slack);

Thanks Jack,

That's new to me!!
I will resend it with suggested changes.

-- 
viresh
