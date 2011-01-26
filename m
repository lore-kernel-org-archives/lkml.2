Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1AZKYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:24:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:35941 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1AZKYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:24:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,379,1291622400"; 
   d="scan'208";a="651301127"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Bob Liu <lliubbo@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "gregkh@suse.de" <gregkh@suse.de>
Date: Wed, 26 Jan 2011 10:23:39 +0000
Subject: RE: [PATCH] firmware_classs: change val uevent's type to bool
Thread-Topic: [PATCH] firmware_classs: change val uevent's type to bool
Thread-Index: Acu9QExTLrCMp6kaSH6NyTqzIdO01AAAsz0u
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D6329795@irsmsx504.ger.corp.intel.com>
References: <1296036004-15644-1-git-send-email-lliubbo@gmail.com>
	<C5C86A19469DAE48AAAD0E5F3716E44501D6329793@irsmsx504.ger.corp.intel.com>,<AANLkTinzHZorkTpDSv5J9_Q5kO5UUFnZb3CAafyOu2Qe@mail.gmail.com>
In-Reply-To: <AANLkTinzHZorkTpDSv5J9_Q5kO5UUFnZb3CAafyOu2Qe@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Bob Liu [lliubbo@gmail.com]
Sent: Wednesday, January 26, 2011 11:03
To: Berg, Johannes
Cc: linux-kernel@vger.kernel.org; chrisw@sous-sol.org; Winkler, Tomas; dmitry.torokhov@gmail.com; gregkh@suse.de
Subject: Re: [PATCH] firmware_classs: change val uevent's type to bool

On Wed, Jan 26, 2011 at 5:56 PM, Berg, Johannes <johannes.berg@intel.com> wrote:
> @@ -463,7 +463,8 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
>        f_dev->parent = device;
>        f_dev->class = &firmware_class;
>
> -       dev_set_uevent_suppress(f_dev, true);
> +       if (uevent)
> +               dev_set_uevent_suppress(f_dev, true);
>
> Everything but this is a no-op basically, but you didn't even describe this change?
>


Hmm.. Sorry for that, but I mentioned that by "fix a place missing
uevent check".
I added this check because I think it should be paired with following
dev_set_uevent_suppress(f_dev, false).

I don't think it should -- if you don't want uevents, then they should _always_ be suppressed, right?

johannes
--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

