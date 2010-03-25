Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0CYSyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:54:04 -0400
Received: from web94915.mail.in2.yahoo.com ([203.104.17.192]:32919 "HELO
	web94915.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754045Ab0CYSyB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:54:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0Rh2lrghqXJLrBsfvYYsCkE+GQUV83IyEdROY/sp7BpAbPjv0D3zaWJxiACo42ZktBEaNMDJ7iR5uP28hyYqz1d8QRlhUQxr2L38TCFDQQnhqK2ElUfiKPAZI/t8zriQw02wp/RJ037Pj5L1VSO8t71GxC+bTIm0HWJltUD6NCI=;
Message-ID: <743646.80702.qm@web94915.mail.in2.yahoo.com>
X-YMail-OSG: bt9bixgVM1neyVxvX5Vtc289TSUtxH.f38Q8VDw.jG6Rffv
 w2fvil0mkv8afMRI6eBqLyalr4J4HUw0kcgjbk.SzckiILAujYnCeEnihs52
 uNqsW5S.MYw_BhGgPVXsmeRtc8.ojf9LLA7jMr5cZFRnzs1I56jkdVwqADV2
 6W9RrBkdObgsabUnaKjpqGu9MoTwaMNw8Sh1kV4YwcuWjf1f96BQhBia9rKj
 5Pd62tTDKlrYd6U8QAoh9Hs92EEDVzhL.wtMF1al7_Pwja5nK38_LFF.T_Ez
 lmDtNwl_PRfdAOpXZ515C0yMdrO9RdT2abWfHYjs0HA--
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Fri, 26 Mar 2010 00:23:55 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: rfkill events from kernel space
To: Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <938191.86865.qm@web94908.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 25/3/10, Pavan Savoy <pavan_savoy@yahoo.co.in> wrote:

> From: Pavan Savoy <pavan_savoy@yahoo.co.in>
> Subject: rfkill events from kernel space
> To: "Johannes Berg" <johannes@sipsolutions.net>, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
> Date: Thursday, 25 March, 2010, 11:59 PM
> How do I send an rfkill event upon
> device /dev/rfkill from kernel space ?
> 
> An action upon my driver, should break the poll on
> /dev/rfkill from a user-space daemon, but sending an
> OP_CHANGE event.
> 
> As I've seen only writing blocked/non-blocked on the sysfs
> entry of an rfkill device generates an rfkill event.
> 
> 
>       Your Mail works best with the New
> Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Please ignore the above message, if you haven't already.
set_sw_state or set_hw_state should have called set_events.



      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
