Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2CEXBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:01:09 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:50184 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757429Ab2CEXBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:01:06 -0500
Message-ID: <4F5545BB.5010608@xenotime.net>
Date: Mon, 05 Mar 2012 15:01:15 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] toshiba_acpi: Expanded hotkey support
References: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com> <20120206150658.GE6414@ubuntu-macmini> <20120206151548.GA30255@srcf.ucam.org> <20120305220407.GA16312@ubuntu-macmini>
In-Reply-To: <20120305220407.GA16312@ubuntu-macmini>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 02:04 PM, Seth Forshee wrote:

> On Mon, Feb 06, 2012 at 03:15:48PM +0000, Matthew Garrett wrote:
>> On Mon, Feb 06, 2012 at 09:06:58AM -0600, Seth Forshee wrote:
>>
>>> Matthew: Just wondering if there are more issues that need to be
>>> addressed with this round of patches, or if they're looking okay at this
>>> point.
>>
>> I'm fine with them at this point, just waiting on Len to give feedback 
>> on the ACPI patch.
> 
> Well, I've been trying to get some comment on the ACPI patch, to no
> avail. Unless there's some other option, I guess I'll just resend the
> patches using an alternative method for getting the EC handle.


I did test this patch series on 3.3-rc5 to see if it would
help with the touchpad on/off key on my Toshiba Portege.

The patch series didn't have any ill effects, nor did it help
with the touchpad on/off key.  :(

-- 
~Randy
