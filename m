Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945900Ab2JYLZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:25:50 -0400
Received: from mga05.intel.com ([192.55.52.89]:10325 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933816Ab2JYLZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D58DE9@ORSMSX108.amr.corp.intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
 <1351000104-13015-3-git-send-email-irina.tirdea@intel.com>
 <CAGXu5jKEuMyDhZB4QDLq9yZLQFjXMq2hXhTEToMyQ_rXwc4TZw@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F19D58DE9@ORSMSX108.amr.corp.intel.com>
From: "Tatulea, Dragos" <dragos.tatulea@intel.com>
Date: Thu, 25 Oct 2012 14:25:26 +0300
Message-ID: <CAJ_JQ2Wv23DOruA673Wukj5yUO9Ru66k1CjQ0h+7+x4iS6FX3Q@mail.gmail.com>
Subject: Re: [PATCH 02/26] pstore: add flags
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Kees Cook <keescook@chromium.org>,
        "Tirdea, Irina" <irina.tirdea@intel.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Chris Ball <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hunter, Adrian" <adrian.hunter@intel.com>,
        "Purdila, Octavian" <octavian.purdila@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 7:57 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> I wonder if the default should be to not show headers, and to add this
>> flag to the backends that want the pstore-added header. I think the
>> more common case going forward will to be without headers since
>> backends should arguably storing metadata themselves.
>
> Perhaps just add the headings when pstore breaks a dump into
> pieces because of a back-end size limitation. I.e. if there is only
> one piece, then no headings. If there are two or more, include
> a heading to aid with putting the pieces together later.
>
But how do you determine the kmsg data size without doing a
kmsg_dump_get_buffer beforehand?

Thanks,
Dragos
