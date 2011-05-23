Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab1EWUxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:53:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1EWUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:53:17 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=opAHw_AlxjwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=iQi6EvK5La-UFNIFbdoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv3] jump_label,x86: make batch update of jump_label
 entries
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110523164541.GE2052@jolsa.brq.redhat.com>
References: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
	 <1304502103-3228-1-git-send-email-jolsa@redhat.com>
	 <20110509183816.GF3981@jolsa.brq.redhat.com>
	 <20110509192726.GB2524@redhat.com>
	 <20110523164541.GE2052@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 23 May 2011 16:53:15 -0400
Message-ID: <1306183995.1465.48.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 18:45 +0200, Jiri Olsa wrote:
> hi,
> any feedback?
> 

Hi Jiri,

I'm just dealing with some bugs people reported related to some of my
work I recently done. I'll start working on this after that. This may
not make it into this merge window, but I'll make sure I push this off
to Ingo for 2.6.41.

Thanks,

-- Steve


